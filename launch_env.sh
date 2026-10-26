#!/usr/bin/env bash

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export VECLIB_MAXIMUM_THREADS=1

# On AGNOS, prefer the managed venv runtime (has required Python deps like pyzmq).
if [ -x /usr/local/venv/bin/python3 ]; then
  export PATH="/usr/local/venv/bin:${PATH}"
fi

# models get lower priority than ui
# - ui is ~5ms
# - modeld is 20ms
# - DM is 10ms
# in order to run ui at 60fps (16.67ms), we need to allow
# it to preempt the model workloads. we have enough
# headroom for this until ui is moved to the CPU.
export QCOM_PRIORITY=12

if [ -z "$AGNOS_VERSION" ]; then
  export AGNOS_VERSION="19.8.1"
fi

if [ -z "$AGNOS_ACCEPTED_VERSIONS" ]; then
  export AGNOS_ACCEPTED_VERSIONS="19.8.1 19.8.2"
fi

export STAGING_ROOT="/data/safe_staging"

# StarPilot variables (only available after StarPilot is installed to /data/openpilot)
if [ -x /data/openpilot/starpilot/system/environment_variables ]; then
  eval "$(/data/openpilot/starpilot/system/environment_variables)"
fi

# === 动态代理设置开始 ===
# 获取当前连接的 Wi-Fi 名称
#CURRENT_SSID=$(iwgetid -r)

#case "$CURRENT_SSID" in
#    "asus_AX86U")
#        export http_proxy="http://192.168.1.21:7890"
#        export https_proxy="http://192.168.1.21:7890"
#        export HTTP_PROXY="http://192.168.1.21:7890"
#        export HTTPS_PROXY="http://192.168.1.21:7890"
#        ;;
#    "另一个热点名称")
#        # 如果有其他网络需要不同的代理，在这里添加
#        export http_proxy="http://其他IP:端口"
#        export https_proxy="http://其他IP:端口"
#        export HTTP_PROXY="http://其他IP:端口"
#        export HTTPS_PROXY="http://其他IP:端口"
#        ;;
#    *)
        # 对于不匹配的 Wi-Fi（例如手机热点、公共 Wi-Fi），确保清除代理，保持直连
#        unset http_proxy
#        unset https_proxy
#        unset HTTP_PROXY
#        unset HTTPS_PROXY
#        ;;
#esac
# === 动态代理设置结束 ===
