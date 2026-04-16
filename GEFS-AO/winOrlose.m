function score = winOrlose(compareCol1,compareCol2)
    [p,q]=ranksum(compareCol1,compareCol2);
    if q == 0
        score = 2;
    else
        [p,q]=ranksum(compareCol1,compareCol2,'tail','left');
        if q==0
            score = 3;
        else
%             disp(dataName)
            score = 1;
        end
    end
end