# aosp-docker
aosp docker 使用的清华的aosp镜像，ubuntu源使用的163

docker run -ti -v /home/asmrobot/aosp/android-4.4.2_r2:/aosp -v /home/asmrobot/aquarius_native:/app -v /home/asmrobot/keye:/artifacts ztaosp/v5 /aosp.sh build aosp_arm-eng  keye

