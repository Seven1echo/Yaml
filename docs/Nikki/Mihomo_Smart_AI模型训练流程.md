# Mihomo_Smart_AI模型训练流程



## 一、 数据收集及提取
1. 修改 Yaml Smart 策略组的 **collectdata** 参数为 **True** ，开启数据收集。建议持续收集数据 **一周以上**，也可阶段性数据收集，基于使用数据更新模型  
<img width="1382" height="167" alt="image" src="https://github.com/user-attachments/assets/b2ee0077-a54c-4285-b04a-e437b2cd21d2" />  

2. 提取 smart_weight_data.csv 至生产环境  
终端登录 Openwrt: **/etc/nikki/run/** ,下载 smart_weight_data.csv 文件到本地
<img width="807" height="400" alt="image" src="https://github.com/user-attachments/assets/376c96a4-98ed-4bf1-9151-7e8a2490c8a4" />  



## 二、 使用 [**Mihomo_Smart_AI模型训练工具.exe**](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/config/smart/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E5%B7%A5%E5%85%B7.exe) 制作 **Model.bin**
1. 打开训练工具后，点击 **浏览** ，选取 smart_weight_data.csv 文件   

2. 点击 **开始训练** ，静待程序跑批完毕，Model.bin 将会生成在桌面  
<img width="948" height="470" alt="image" src="https://github.com/user-attachments/assets/ef8c1213-4c45-4c94-bd88-1571dca55306" />  

3. 上传 Model.bin 至 OpenWrt：**/etc/nikki/run/** ，正常使用即可
<img width="317" height="348" alt="image" src="https://github.com/user-attachments/assets/4234cfe3-fe56-47f6-a8dc-bb5270a647d4" />



## 三、使用提示
1. 使用自己的 **Model.bin** ，需要注意Yaml里的模型相关参数，是否删除或者注释掉，不然会自动更新为官方模型
2. 当感觉自己的 **Model.bin** ，已经成熟了，记得设置Smart策略组的 **collectdata** 参数为 **False** ,不然会一直收集使用数据
<img width="1024" height="121" alt="image" src="https://github.com/user-attachments/assets/dc917a14-80f4-4945-9513-f62cc724f0a8" />  

```
# ══ 模型数据 ══
lgbm-url: "https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model-large.bin"
lgbm-auto-update: true                                                  # 自动更新  LightGBM 模型
lgbm-update-interval: 24                                                # 更新间隔  单位：小时
```






