
%% 自检环境中是否存在eeglab，并加载eeglab。如果不存在eeglab，需要选择eeglab.m文件路径。
clear;clc;
path_all = path;
path_per = split(path_all,';');
eeglab_exit = 0;

for i=1:1:length(path_per)
    if contains(path_per(i),'eeglab')
        eeglab_exit = 1;
        try
            eeglab nogui
        catch Exception
            opts = struct('WindowStyle','modal',... 
                  'Interpreter','tex');
            h = warndlg('路径中包含eeglab路径错误，请手动选择eeglab.m文件','EEGLAB路径错误',opts);
            uiwait(h);
            eeglab_exit = 0;
        end 
        break
    end
end

if ~eeglab_exit
    [eeglabfilename, eeglabpathname] = uigetfile({'eeglab.m;'}, '请选择您的eeglab.m文件','MultiSelect', 'on');
    path(path,eeglabpathname);
    eeglab_exit = 1;
    try
        eeglab nogui
    catch Exception
        opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
        h = warndlg('请输出正确的eeglab路径','EEGLAB路径错误',opts);
        uiwait(h);
        eeglab_exit = 0;
    end 
end


%% 从bdf导入数据，Neuracle数据有两种，如果是bdf文件，需要两个bdf文件；如果是edf文件，只需要一个
if eeglab_exit
    [filename, pathname] = uigetfile({'*.bdf;*.edf';'*.*'}, '请选择需要转换的pdf或者edf文件','MultiSelect', 'on');
    if ~isa(filename,'cell')
        if (filename) == 0
            opts = struct('WindowStyle','modal',... 
                  'Interpreter','tex');
            h = warndlg('没有选择文件','Error',opts);
            uiwait(h);
            return
        end
    end
    disp('importing');
    try
        EEG = readbdfdata(filename, pathname);
    catch Exception
        if (strcmp(Exception.identifier,'MATLAB:UndefinedFunction'))
            opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
            h = warndlg('eeglab路径错误或 没有NeuracleEEGFileReader插件,点击确定进行插件导入','Error',opts);
            uiwait(h);

            path_all = path;
            path_per = split(path_all,';');
            eeg_path_list = {};
            for i=1:1:length(path_per)
                if contains(path_per(i),'eeglab') && contains(path_per(i),'plugins')
                    eeg_path_list(length(eeg_path_list)+1) = path_per(i);
                end
            end
            eeg_path_length_list = [];
            for i=1:1:length(eeg_path_list)
                eeg_path_length_list(length(eeg_path_length_list)+1) = length(cell2mat(eeg_path_list(i)));
            end
            [m,n] = min(eeg_path_length_list);

            target_path = cell2mat(eeg_path_list(n));
            copyfile('NeuracleEEGFileReader1.2',[target_path,'\NeuracleEEGFileReader1.2'])

            opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
            h = warndlg('NeuracleEEGFileReader插件导入完成，请重新运行程序','Error',opts);
            uiwait(h);
            return
        end
    end 
    disp('import finish');

%% 将原始数据、事件标签读取出来
EEG_origin = EEG.data;
EEG_event = EEG.event;

%% 根据triggerbox标注的event标签进行切割操作
disp('spliceing');
EEG_splice(EEG_origin,EEG_event);
disp('splice finish, the data was alredy saved by EEG_DATA_CONTROL.mat and EEG_DATA_RESET.mat');

end