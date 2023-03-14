# Neuracle-EEG_DATA-Splice
适用于Neuracle脑电设备（64通道）所采集数据的的切割分段处理

## 主要功能：
### 1.自检matlab环境中是否存在eeglab。
### 2.支持选择eeglab版本（前提是在matlab环境中没有已存在的eeglab）。
### 3.支持NeuracleEEGFileReader1.2插件的自动安装。该插件用于读取Neuracle脑电设备采集数据的读取。
### 4.根据用户需求，对EEG_splice.m程序进行修改，根据EEG结构体中event的事件标签来进行截取。其中duration为截取数据采样点长度，根据实际情况进行调整。
### 5.支持多通道选择提取。
