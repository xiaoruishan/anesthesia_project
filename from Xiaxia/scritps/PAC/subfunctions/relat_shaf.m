function PAC0=relat_shaf(PAC)
% 将原始数据PAC值与shaffle数据PAC做相对值。PAC为结构数据
[m,n]=size(PAC.pacmat);
relat=PAC.pacmat-PAC.shf_data_mean;
relatperc=(PAC.pacmat-PAC.shf_data_mean)./PAC.shf_data_mean;
relat_mi=(PAC.pacmat-PAC.shf_data_mean)./PAC.shf_data_std;
for i=1:n
    for j=1:m
        if relat(j,i)<0
            relat(j,i)=0;
        end
        if relatperc(j,i)<0
            relatperc(j,i)=0;
        end
        if relat_mi(j,i)<0
            relat_mi(j,i)=0;
        end
    end
end
PAC.pac_relat=relat;
PAC.pac_relatperc=relatperc;
PAC.relat_mi=relat_mi;
PAC0=PAC;
end