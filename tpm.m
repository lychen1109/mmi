function D=tpm(img)
% transition probability matrix of img

[N,M]=size(img);
diff_field=zeros(N-1,M-1,4);
diff_field(1:N-1,1:M-1,1)=img(1:N-1,1:M-1)-img(2:N,1:M-1);
diff_field(1:N-1,1:M-1,2)=img(1:N-1,1:M-1)-img(1:N-1,2:M);
diff_field(1:N-1,1:M-1,3)=img(1:N-1,1:M-1)-img(2:N,2:M);
diff_field(1:N-1,1:M-1,4)=img(2:N,1:M-1)-img(1:N-1,2:M);

m_size=255*2+1;

D=zeros(m_size,m_size,4);
diff_field=diff_field+256;

for i=1:N-2
    for j=1:M-2
        D(diff_field(i,j,1),diff_field(i+1,j,1),1)=D(diff_field(i,j,1),diff_field(i+1,j,1),1)+1;
        D(diff_field(i,j,2),diff_field(i,j+1,2),2)=D(diff_field(i,j,2),diff_field(i,j+1,2),2)+1;
        D(diff_field(i,j,3),diff_field(i+1,j+1,3),3)=D(diff_field(i,j,3),diff_field(i+1,j+1,3),3)+1;
        D(diff_field(i+1,j,4),diff_field(i,j+1,4),4)=D(diff_field(i+1,j,4),diff_field(i,j+1,4),4)+1;
    end
end

for d=1:4
    for i=1:m_size
        t=sum(D(i,1:m_size,d));
        if t>0
           D(i,1:m_size,d)=D(i,1:m_size,d)/t; 
        end
    end
end