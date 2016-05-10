# NHAutoTestPro
iOS自动化测试、可持续集成的探讨！（Macintosh环境）


* * *

#### 使用到的工具：
```
＊Xcode7.0+
＊Jenkins2.2
＊Git service
＊SSH service
```

* * *

##### Xcode的安装:
比较简单，打开App Store搜索到Xcode，下载安装即可!


##### Jenkins的安装:
比较简单，去[官网](http://baidu.com)下载最新版本(作者的是v2.2)，安装过程当中会要求安装plugin插件、创建一个admin账号密码，和普通软件安装一样按照提示一步步安装即可!
如下图：

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_0.png)

- 创建新任务
1. 点击新建或创建一个新任务，输入任务的名称、选择类型，这里选择第一个类型（构建一个自由风格的软件项目），点击OK如下图：

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_1.png)

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_2.png)

- 源码管理（重点）
1. 这里终点讨论源码地址为Git的情况（svn或其他的不再讨论）
2. Git地址简单分为两种：使用Github服务的项目和自己搭建Gitlab服务的项目（并且搭建了ssh棉密码登陆的情况），两种地址简单区分为：
	a:https://github.com/iFindTA/NHNewsBoardPro.git(默认Github)
	b:ssh:git@192.168.11.103:33033/home/xxxx.git(默认Gitlab)

- - -
先讨论a情况：
1，直接输入Repository URL

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoic_7.png)

2，在Credentials项点击"Add"按钮添加凭证，如图：

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_4.png)

3，选择 "Username with password" 选项填写然后点击 "Add"即可

再讨论b情况，稍微复杂一点，因为牵涉到ssh，不熟悉的可参考[ssh资料](https://zh.wikipedia.org/wiki/Secure_Shell)

```
准备工作，假设此时Gitlab搭建人员为你创建了用户:ack 密码：xxx
```

1，首先生成ssh keys，打开terminal终端

2，输入命令：
```
$ ssh-keygen -t rsa -C "something"
```
note:"something" 在此即为user name：ack，即完整命令如下：
```
$ ssh-keygen -t rsa -C "ack"
```
否则验证不通过！

3，一路press enter下去 （不用设置passphrase！！！）成功的话会看到如下效果:

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_8.png)

4，在Finder中查看如下：

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_10.png)

如果直接打开/users/用户名下查看是看不到.ssh文件夹的，可以用如下命令显示或隐藏文件夹:
```
chglags hidden xxx
chflags nohidden xxx

```

5，你需要将id_rsa.pub公钥文件上传到Gitlab后端，或者将此文件交给Gitlab维护人员

6，获取私钥，如下命令：
```
$ cat /users/nanhujiaju/.ssh/id_rsa
```
你将看到如下效果:

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_9.png)

复制private key，注意包括-----Begin和END RSA PRIVATE KEY-----部分，不要漏掉！！！

7，创建Credentials：
Credentials类型选择 "SSH Username with private key"

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_5.png)

username填写ack，private key复制粘贴刚才的key 点击"Add"即可验证通过！！！

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_6.png)

最终效果如下：

![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/autoci_7.png)

- 构建触发器
- 构件环境
- 构件（脚本的执行）
- 构件后操作
这几部分的设置相对简单，可查阅相关资料进行相关设置：
[jenkins-study](https://github.com/hudongcheng/jenkins-study)
[GitLab Documentation](http://doc.gitlab.com/ee/integration/jenkins.html)
[远程shell的执行](http://blog.csdn.net/fireofjava/article/details/40624353)

