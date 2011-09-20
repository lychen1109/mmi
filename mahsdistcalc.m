function md=mahsdistcalc(tm1,tm2,sigma)
%calculate mahs distance

md=sqrt((tm1(:)-tm2(:))'*sigma*(tm1(:)-tm2(:)));