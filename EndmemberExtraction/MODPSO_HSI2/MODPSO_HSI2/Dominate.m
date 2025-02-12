function dom=Dominate(x,y)

    dom=all(x<=y) & any(x<y);
end