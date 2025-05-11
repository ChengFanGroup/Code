# python packages
import random
import time
import operator
import evalGP_main as evalGP
# only for strongly typed GP
import gp_restrict
import numpy as np
# deap package
from deap import base, creator, tools, gp
from strongGPDataType import Int1, Int2, Int3,Int4,Int5, Img, Region,Region1,Region2, Region3,Vector, Vector1
import feature_function as fe_fs
from sklearn.svm import LinearSVC
from sklearn.model_selection import cross_val_score
from sklearn import preprocessing
import warnings
warnings.filterwarnings("ignore")#消除警告

dataSetName='FS'
randomSeeds=10

x_train = np.load(dataSetName + '_train_data.npy')/ 255.0
y_train = np.load(dataSetName + '_train_label.npy')
x_test = np.load(dataSetName + '_test_data.npy')/ 255.0
y_test = np.load(dataSetName + '_test_label.npy')

print(x_train.shape)#输出训练集大小（数量，宽度，高度）
print(x_test.shape)#输出测试集大小（数量，宽度，高度）

# parameters:
population = 100
generation = 40
cxProb = 0.8#交叉率
mutProb = 0.19#变异率
elitismProb = 0.01#精英主义概率
totalRuns = 30
initialMinDepth = 2
initialMaxDepth = 4
maxDepth = 4

bound1, bound2 = x_train[1, :, :].shape
##GP

pset = gp.PrimitiveSetTyped('MAIN', [Img], Vector1, prefix='Image')

pset.addPrimitive(fe_fs.root_con, [Vector, Vector, Vector,Vector], Vector1, name='FeaCon4')
pset.addPrimitive(fe_fs.root_con, [Vector, Vector, Vector,Vector,Vector], Vector1, name='FeaCon5')


pset.addPrimitive(fe_fs.global_hog, [Img], Vector, name='Global_HOG')
pset.addPrimitive(fe_fs.all_lbp, [Img], Vector, name='Global_uLBP')
pset.addPrimitive(fe_fs.gabor_filt_imag,[Img],Vector,name='Gabor_filt_image')
pset.addPrimitive(fe_fs.gabor_filt_real,[Img],Vector,name='Gabor_filt_real')
pset.addPrimitive(fe_fs.all_sift, [Img], Vector, name='SIFT')
pset.addPrimitive(fe_fs.all_histogram, [Img], Vector, name='Global_Histogram')


pset.addPrimitive(fe_fs.local_hog, [Region], Vector, name='Local_HOG')
pset.addPrimitive(fe_fs.all_lbp, [Region], Vector, name='Local_uLBP')
pset.addPrimitive(fe_fs.gabor_filt_imag,[Region],Vector,name='Gabor_filt_image')
pset.addPrimitive(fe_fs.gabor_filt_real,[Region],Vector,name='Gabor_filt_real')
pset.addPrimitive(fe_fs.all_sift, [Region], Vector, name='SIFT')
pset.addPrimitive(fe_fs.all_histogram, [Region], Vector, name='Histogram')


pset.addPrimitive(fe_fs.Resize, [Img, Int4, Int5], Region, name='Resize')#获得不同尺度的全局图之后交由特征提取函数提取特征
pset.addPrimitive(fe_fs.GausDown1, [Img], Region, name='GDown_1')#获得不同尺度的全局图之后交由特征提取函数提取特征
pset.addPrimitive(fe_fs.GausDown2, [Img], Region, name='GDown_2')
pset.addPrimitive(fe_fs.GausUp1, [Img], Region, name='GUp_1')
pset.addPrimitive(fe_fs.GausUp2, [Img], Region, name='GUp_2')


pset.addPrimitive(fe_fs.regionS, [Img, Int1, Int2, Int3], Region, name='Gup_1_Region_S')#[Img,X,Y,Size]
pset.addPrimitive(fe_fs.regionR, [Img, Int1, Int2, Int3, Int3], Region, name='Gup_1_Region_R')
pset.addPrimitive(fe_fs.regionS, [Img, Int1, Int2, Int3], Region, name='Gup_1_Region_S')#[Img,X,Y,Size]
pset.addPrimitive(fe_fs.regionR, [Img, Int1, Int2, Int3, Int3], Region, name='Gup_1_Region_R')
pset.addPrimitive(fe_fs.Resize, [Img, Int4, Int5], Region, name='Resize')#获得不同尺度的全局图之后交由特征提取函数提取特征
pset.addPrimitive(fe_fs.GausDown1, [Img], Region, name='GDown_1')#获得不同尺度的全局图之后交由特征提取函数提取特征
pset.addPrimitive(fe_fs.GausDown2, [Img], Region, name='GDown_2')
pset.addPrimitive(fe_fs.GausUp1, [Img], Region, name='GUp_1')
pset.addPrimitive(fe_fs.GausUp2, [Img], Region, name='GUp_2')


pset.renameArguments(ARG0='Grey')
pset.addEphemeralConstant('X', lambda: random.randint(0, bound1 - 10), Int1)

pset.addEphemeralConstant('Y', lambda: random.randint(0, bound2 - 10), Int2)
pset.addEphemeralConstant('Size', lambda: random.randint(20,  bound1 - 10), Int3)
pset.addEphemeralConstant('Weight', lambda: random.randint(20, bound1), Int4)
pset.addEphemeralConstant('Height', lambda: random.randint(20, bound2), Int5)


creator.create("FitnessMax", base.Fitness, weights=(1.0,))#适应度表现为base模块中的Fitness基类
creator.create("Individual", gp.PrimitiveTree, fitness=creator.FitnessMax)#个体类表现为一个gp.PrimitiveTree


toolbox = base.Toolbox()

toolbox.register("expr", gp_restrict.genHalfAndHalfMD, pset=pset, min_=initialMinDepth, max_=initialMaxDepth)
toolbox.register("individual", tools.initIterate, creator.Individual, toolbox.expr)
toolbox.register("population", tools.initRepeat, list, toolbox.individual)
toolbox.register("compile", gp.compile, pset=pset)
toolbox.register("mapp", map)#map() 会根据提供的函数对指定序列做映射。


def evalTrain(individual):

    func = toolbox.compile(expr=individual)
    train_tf = []
    for i in range(0, len(y_train)):
        train_tf.append(np.asarray(func(x_train[i, :, :])))
    min_max_scaler = preprocessing.MinMaxScaler()#最大最小归一化
    train_norm = min_max_scaler.fit_transform(np.asarray(train_tf))
    # print(train_norm.shape)
    lsvm = LinearSVC(max_iter=100,dual=False)
    accuracy = round(100 * cross_val_score(lsvm, train_norm, y_train, cv=5).mean(), 2)##获得训练样本的精确度 重复100次获得 max min avg std  round(,2)这里的2代表小数点位数
    return accuracy,

# genetic operator 遗传算子
toolbox.register("evaluate", evalTrain)
toolbox.register("select", tools.selTournament, tournsize=5)
toolbox.register("selectElitism", tools.selBest)
toolbox.register("mate", gp.cxOnePoint)
toolbox.register("expr_mut", gp_restrict.genFull, min_=0, max_=2)
toolbox.register("mutate", gp.mutUniform, expr=toolbox.expr_mut, pset=pset)
toolbox.decorate("mate", gp.staticLimit(key=operator.attrgetter("height"), max_value=maxDepth))
toolbox.decorate("mutate", gp.staticLimit(key=operator.attrgetter("height"), max_value=maxDepth))

def GPMain(randomSeeds):
    random.seed(randomSeeds)

    pop = toolbox.population(population)
    hof = tools.HallOfFame(5)#名人堂10个或许太多，运算时间长 可以尝试改为存储5个
    log = tools.Logbook()
    stats_fit = tools.Statistics(key=lambda ind: ind.fitness.values)
    stats_size_tree = tools.Statistics(key=len)#用于统计树个体的大小（节点数）。key=len 指定了用于计算大小的函数，即将树个体的长度（节点数）作为统计数据。
    mstats = tools.MultiStatistics(fitness=stats_fit, size_tree=stats_size_tree)
    mstats.register("avg", np.mean)
    mstats.register("std", np.std)
    mstats.register("min", np.min)
    mstats.register("max", np.max)
    log.header = ["gen", "evals"] + mstats.fields

    pop, log = evalGP.eaSimple(pop, toolbox, cxProb, mutProb, elitismProb, generation,
                               stats=mstats, halloffame=hof, verbose=True)

    return pop, log, hof

def evalTest(individual):
    func = toolbox.compile(expr=individual)
    train_tf = []
    test_tf = []
    for i in range(0, len(y_train)):
        train_tf.append(np.asarray(func(x_train[i, :, :])))
    for j in range(0, len(y_test)):
        test_tf.append(np.asarray(func(x_test[j, :, :])))
    train_tf = np.asarray(train_tf)
    test_tf = np.asarray(test_tf)
    min_max_scaler = preprocessing.MinMaxScaler()
    train_norm = min_max_scaler.fit_transform(np.asarray(train_tf))
    test_norm = min_max_scaler.transform(np.asarray(test_tf))
    lsvm= LinearSVC(max_iter=100,dual=False)
    lsvm.fit(train_norm, y_train)
    accuracy = round(100*lsvm.score(test_norm, y_test),2)#round(,2)这里的2代表小数点位数
    return train_tf.shape[1], accuracy

if __name__ == "__main__":
    while randomSeeds>2:
        beginTime = time.process_time()
        pop, log, hof = GPMain(randomSeeds)
        endTime = time.process_time()
        trainTime = endTime - beginTime

        num_features, testResults = evalTest(hof[0])
        endTime1 = time.process_time()
        testTime = endTime1 - endTime

        print('Best individual ', hof[0])
        print('num_features', num_features)
        print('Test results  ', testResults)
        print('Train time  ', trainTime)
        print('Test time  ', testTime)
        print('DateSet', dataSetName)
        print('Generations', generation)
        print('randomSeeds', randomSeeds)
        print('End')
        randomSeeds-=1;
