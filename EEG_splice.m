function EEG_splice(EEG_DATA,EEG_EVENT)
%EEG_SPLICE 此处显示有关此函数的摘要
%   此处显示详细说明
list = {'Fpz','Fp1','Fp2','AF3','AF4','AF7','AF8','Fz','F1','F2','F3','F4','F5','F6','F7','F8','FCz','FC1','FC2','FC3','FC4','FC5','FC6','FT7','FT8','Cz','C1','C2','C3','C4','C5','C6','T7','T8','CP1','CP2','CP3','CP4','CP5','CP6','TP7','TP8','Pz','P3','P4','P5','P6','P7','P8','POz','PO3','PO4','PO5','PO6','PO7','PO8','Oz','O1','O2','ECG','HEOR','HEOL','VEOU','VEOL'};

[indx,tf] = listdlg('PromptString',{'请选择需要提取的通道',...
    '按住shift区域多选','ctrl单个多选'},'ListString',list);

duration = 6000;

EEG_DATA_RESET = [];
EEG_DATA_CONTROL = [];

EEG_DATA_FIRST_RESET = [];
EEG_DATA_FIRST_CONTROL = [];

for i=1:1:length(EEG_EVENT)
    if EEG_EVENT(i).type ~= '0'
        if EEG_EVENT(i).type == '1' || EEG_EVENT(i).type == '2'|| EEG_EVENT(i).type == '3'|| EEG_EVENT(i).type == '4'
            index_start = EEG_EVENT(i).latency;
            index_end = EEG_EVENT(i).latency+duration-1;
            if isempty(EEG_DATA_CONTROL)
                if ~isempty(EEG_DATA_FIRST_RESET)
                    EEG_DATA_CONTROL = cat(3,EEG_DATA_FIRST_RESET,EEG_DATA(indx,index_start:index_end));
                else
                    EEG_DATA_FIRST_RESET = EEG_DATA(indx,index_start:index_end);
                end
            else
                EEG_DATA_CONTROL(:,:,size(EEG_DATA_CONTROL,3)+1) = EEG_DATA(indx,index_start:index_end);
            end
           
        end

        if EEG_EVENT(i).type == '5'
            index_start = EEG_EVENT(i).latency;
            index_end = EEG_EVENT(i).latency+duration-1;
            if isempty(EEG_DATA_RESET)
                if ~isempty(EEG_DATA_FIRST_CONTROL)
                    EEG_DATA_RESET = cat(3,EEG_DATA_FIRST_CONTROL,EEG_DATA(indx,index_start:index_end));
                else
                    EEG_DATA_FIRST_CONTROL = EEG_DATA(indx,index_start:index_end);
                end
            else
                EEG_DATA_RESET(:,:,size(EEG_DATA_RESET,3)+1) = EEG_DATA(indx,index_start:index_end);
            end
           
        end
    end
end
save EEG_DATA_CONTROL.mat EEG_DATA_CONTROL -mat
save EEG_DATA_RESET.mat EEG_DATA_RESET -mat
end

