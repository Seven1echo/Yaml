# Mihomo_Smart_AI模型训练流程



## 一、 数据收集及提取
1. 修改 Yaml Smart 策略组的 **collectdata** 参数为 **True** ，开启数据收集。建议持续收集数据 **一周以上**，也可阶段性数据收集，基于使用数据更新模型  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E6%B5%81%E7%A8%8B/1.%E5%8F%82%E6%95%B0.jpg)

2. 提取 smart_weight_data.csv 至生产环境  
终端登录 Openwrt: **/etc/nikki/run/** ,下载 smart_weight_data.csv 文件到本地
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E6%B5%81%E7%A8%8B/2.%E6%8F%90%E5%8F%96.jpg)



## 二、 使用 [**Mihomo_Smart_AI模型训练工具.exe**](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/smart/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E5%B7%A5%E5%85%B7.exe) 制作 **Model.bin**
1. 打开训练工具后，点击 **浏览** ，选取 smart_weight_data.csv 文件   

2. 点击 **开始训练** ，静待程序跑批完毕，Model.bin 将会生成在桌面  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E6%B5%81%E7%A8%8B/3.%E8%AE%AD%E7%BB%83.jpg)  

3. 上传 Model.bin 至 OpenWrt：**/etc/nikki/run/** ，正常使用即可  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E6%B5%81%E7%A8%8B/4.%E6%9B%BF%E6%8D%A2.jpg)  



## 三、使用提示
1. 使用自己的 **Model.bin** ，需要注意Yaml里的模型相关参数，是否删除或者注释掉，不然会自动更新为官方模型
2. 当感觉自己的 **Model.bin** ，已经成熟了，记得设置Smart策略组的 **collectdata** 参数为 **False** ,不然会一直收集使用数据
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E6%B5%81%E7%A8%8B/5.%E6%8F%90%E7%A4%BA.jpg)

```
# ══ 模型数据 ══
lgbm-url: "https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin"
lgbm-auto-update: true                                                  # 自动更新  LightGBM 模型
lgbm-update-interval: 24                                                # 更新间隔  单位：小时
```






