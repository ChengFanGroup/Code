function p=selectsubset(bucket)

 row_sum = sum(bucket,2);
 row_sum = row_sum';
 p = find(row_sum ==2);



end