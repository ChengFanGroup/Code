import random
import sys
import warnings
from inspect import isclass
from deap import  gp
# Define the name of type for any types.
__type__ = object
######################################
# GP Program generation functions    #
######################################
def genFull(pset, min_, max_, type_=None):
    """Generate an expression where each leaf has a the same depth
    between *min* and *max*.

    :param pset: Primitive set from which primitives are selected.
    :param min_: Minimum height of the produced trees.
    :param max_: Maximum Height of the produced trees.
    :param type_: The type that should return the tree when called, when
                  :obj:`None` (default) no return type is enforced.
    :returns: A full tree with all leaves at the same depth.
    """
    def condition(height, depth):
        """Expression generation stops when the depth is equal to height."""
        return depth == height
    #print('it works', pset)
    return generate(pset, min_, max_, condition, type_)

def genGrow(pset, min_, max_, type_=None):
    """Generate an expression where each leaf might have a different depth
    between *min* and *max*.

    :param pset: Primitive set from which primitives are selected.
    :param min_: Minimum height of the produced trees.
    :param max_: Maximum Height of the produced trees.
    :param type_: The type that should return the tree when called, when
                  :obj:`None` (default) no return type is enforced.
    :returns: A grown tree with leaves at possibly different depths.
    """
    def condition(height, depth):
        """Expression generation stops when the depth is equal to height
        or when it is randomly determined that a a node should be a terminal.
        """
        return depth == height or depth >= min_
    return generate(pset, min_, max_, condition, type_)

def genHalfAndHalf(pset, min_, max_, type_=None):
    """Generate an expression with a PrimitiveSet *pset*.
    Half the time, the expression is generated with :func:`~deap.gp.genGrow`,
    the other half, the expression is generated with :func:`~deap.gp.genFull`.

    :param pset: Primitive set from which primitives are selected.
    :param min_: Minimum height of the produced trees.
    :param max_: Maximum Height of the produced trees.
    :param type_: The type that should return the tree when called, when
                  :obj:`None` (default) no return type is enforced.
    :returns: Either, a full or a grown tree.
    """
    method = random.choice((genGrow, genFull))
    #print(method)
    return method(pset, min_, max_, type_)

def genRamped(pset, min_, max_, type_=None):
    """
    .. deprecated:: 1.0
        The function has been renamed. Use :func:`~deap.gp.genHalfAndHalf` instead.
    """
    warnings.warn("gp.genRamped has been renamed. Use genHalfAndHalf instead.",
                  FutureWarning)
    return genHalfAndHalf(pset, min_, max_, type_)

def                        generate(pset, min_, max_, condition, type_=__type__):
    """Generate a Tree as a list of list. The tree is build
    from the root to the leaves, and it stop growing when the
    condition is fulfilled.
    :param pset: A primitive set from wich to select primitives of the trees.
    :param min_: Minimum height of the produced trees.
    :param max_: Maximum Height of the produced trees.
    :param condition: The condition is a function that takes two arguments,
                      the height of the tree to build and the current
                      depth in the tree.
    :param type_: The type that should return the tree when called, when
                  :obj:`None` (default) no return type is enforced.
    :returns: A grown tree with leaves at possibly different depths
              dependending on the condition function.


    DUMMY NODE ISSUES

    DEAP will only place terminals if we're at the bottom of a branch.
    This creates two issues:
    1. A primitive that takes other primitives as inputs could be placed at the
        second to last layer.
        SOLUTION: You need to allow the tree to end whenever the height condition is met,
                    so create "dummy" terminals for every type possible in the tree.
    2. A primitive that takes terminals as inputs could be placed above the second to
        last layer.
        SOLUTION: You need to allow the tree to continue extending the branch until the
                    height condition is met, so create "dummy" primitives that just pass
                    through the terminal types.

    These "dummy" terminals and "dummy" primitives introduce unnecessary and sometimes
    nonsensical solutions into populations. These "dummy" nodes can be eliminated
    if the height requirement is relaxed.


    HOW TO PREVENT DUMMY NODE ISSUES

    Relaxing the height requirement:
    When at the bottom of the branch, check for terminals first, then primitives.
        When checking for primitives, skirt the height requirement by adjusting
        the branch depth to be the second to last layer of the tree.
        If neither a terminal or primitive fits this node, then throw an error.
    When not at the bottom of the branch, check for primitives first, then terminals.

    Issue with relaxing the height requirement:
    1. Endless loops are possible when primitive sets have any type loops.
        A primitive with an output of one type may not take an input type of
        itself or a parent type.
        SOLUTION: A primitive set must be well-designed to prevent those type loops.

    """
    if type_ is None:
        type_ = pset.ret
    expr = []
    height = random.randint(min_, max_)
    stack = [(0, type_)]
    #print(pset.terminals)
    #print(pset.primitives)
    while len(stack) != 0:
        depth, type_ = stack.pop()
        # At the bottom of the tree
        if condition(height, depth):
            # Try finding a terminal
            try:
                term = random.choice(pset.terminals[type_])
                #print('term',term)
                if isclass(term):
                    term = term()
                expr.append(term)
                # No terminal fits
            except:
                # So pull the depth back one layer, and start looking for primitives
                try:
                    depth -= 1
                    prim = random.choice(pset.primitives[type_])
                    #print('prim',prim)
                    expr.append(prim)
                    for arg in reversed(prim.args):
                        stack.append((depth + 1, arg))

                        # No primitive fits, either - that's an error
                except IndexError:
                    _, _, traceback = sys.exc_info()
                    raise IndexError("The gp.generate function tried to add " \
                                     "a primitive of type '%s', but there is " \
                                     "none available." % (type_,), traceback)

        # Not at the bottom of the tree
        else:
            # Check for primitives
            try:
                prim = random.choice(pset.primitives[type_])
                expr.append(prim)
                for arg in reversed(prim.args):
                    stack.append((depth + 1, arg))
                    # No primitive fits
            except:
                # So check for terminals
                try:
                    term = random.choice(pset.terminals[type_])

                # No terminal fits, either - that's an error
                except IndexError:
                    _, _, traceback = sys.exc_info()
                    raise IndexError("The gp.generate function tried to add " \
                                      "a terminal of type '%s', but there is " \
                                      "none available." % (type_,), traceback)
                if isclass(term):
                    term = term()
                expr.append(term)
    #print(len(expr))
    # print(individual)
    #计数fecon2、fecon3的个数，起码两者有一个
    return expr

def genHalfAndHalfMD(pset, min_, max_, type_=None):
    expr=genHalfAndHalf(pset, min_, max_, type_=None)
    #print('expr before', len(expr))
    while len(expr)>60:# len(expr)<20 or len(expr)>40保证每一代初始化的种群个体的节点数20-40之间,当然在进化后，因为有交叉变异，每一代统计个体节点数（尺寸大小）时，可能会<20，（但由于交叉子树深度为2，可能也就差3-6个节点）
        expr=genHalfAndHalf(pset, min_, max_, type_=None)
        #print('expr before', len(expr))
    #print('expr after',len(expr))
    return expr

def genFullMD(pset, min_, max_, type_=None):
    expr=genFull(pset, min_, max_, type_=None)
    #print('expr before', len(expr))
    while len(expr)>60:
        expr=genFull(pset, min_, max_, type_=None)
        #print('expr before', len(expr))
    #print('expr after',len(expr))
    return expr
