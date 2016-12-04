# aosp-docker
aosp docker
docker 加速建议使用阿里云
ubuntu源使用的163
repo更新时使用的清华的repo镜像
列一些主要的分支：
branch                  sdk level
android-4.4_r1          19
android-4.4.2_r2
android-4.4.4_r2.0.1
android-4.4w_r1         20
android-5.0.0_r1        21
android-5.0.2_r3
android-5.1.0_r1        22
android-5.1.1_r38
android-6.0.0_r1        23
android-6.0.1_r74
android-7.0.0_r1        24
android-7.1.0_r7

编译目标类型各个版本有所不同大概的有：
     aosp_arm-eng
     aosp_x86-eng
     aosp_mips-eng
     vbox_x86-eng
     aosp_hammerhead-userdebug
     aosp_mako-userdebug
     mini_mips-userdebug
     mini_x86-userdebug
     mini_armv7a_neon-userdebug
     aosp_grouper-userdebug
     aosp_tilapia-userdebug
     aosp_flo-userdebug
     aosp_deb-userdebug
     aosp_manta-userdebug


我是从本机镜像同步的，git://192.168.2.111/platform/manifest.git
你可以从清华的AOSP镜像同步：https://aosp.tuna.tsinghua.edu.cn/platform/manifest


命令:
  checkout一个分支：checkout-branch <mirrorurl> <branch> [sync-options]
    必须的volumes:
      /aosp       你想要存放aosp源码的目录
    Checks out 一个指定的分支到 /aosp.
  编译全部全部：build-all <target> [make-options]
    必须的volumes:
      /aosp       存放aosp源码的目录
    用你指定的target编译所有的/aosp 目录中的源码树。
  编译指定模块：build <target> <appname> [make-options]
    必须的volumes:
      /app        app存放代码的目录 (i.e.包含 Android.mk 的目录)
      /aosp       存放aosp源码的目录
      /artifacts  app代码生成后的目录
    用你指定的target编译/app源码，程序会先把/app复制到 /aosp/external/MY_<appname>
    . <appname> 必须不有冲突
    with with any built-in project or your module will not build. The
    prefix is added so that even if you accidentally do use a built-in
    name, at the very least you won't overwrite the files. Note that
    <local-module> must match the LOCAL_MODULE value in your Android.mk
    exactly. You will also need to set \`LOCAL_MODULE_TAGS := optional\` in
    your Android.mk because the build system requires it.
    当编辑成功后任何 shared/static libraries and executables 都会被复制到 /artifacts.
  帮助命令：help
    显示此文档


示例：
生成image:docker build -t ztaosp/jdk6 .
checkout: docker run -ti -v /home/asmrobot/aosp/android-4.4.2_r2:/aosp ztaosp/jdk6 /aosp.sh git://192.168.2.111/platform/manifest.git android-4.4.2_r2
编译全部： docker run -ti -v /home/asmrobot/aosp/android-4.4.2_r2:/aosp ztaosp/jdk6 /aosp.sh build-all aosp_arm-eng
编译KEYE： docker run -ti -v /home/asmrobot/aosp/android-4.4.2_r2:/aosp -v /home/asmrobot/aquarius_native:/app -v /home/asmrobot/keye:/artifacts ztaosp/jdk6 /aosp.sh build aosp_arm-eng  keye
