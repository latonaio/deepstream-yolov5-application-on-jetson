.PHONY: build-pytorch
build-pytorch: ## pytorchのdocker imageをbuildします
	docker-compose build pytorch-yolov5

.PHONY: build-deepstream
build-deepstream: ## deepstreamのdocker imageをbuildします
	docker-compose build deepstream-yolov5

.PHONY: copy-weights-file
copy-weights-file: ## 生成された学習ファイルをマウント先にコピーする
	cd /opt/nvidia/deepstream/deepstream/sources/yolov5 && mv yolov5n.cfg /app/src/models
	cd /opt/nvidia/deepstream/deepstream/sources/yolov5 && mv yolov5n.wts /app/src/models

.PHONY: exec
exec: ## 動画を解析する
	cp /app/src/configs/* /opt/nvidia/deepstream/deepstream-6.0/sources/DeepStream-Yolo
	cd /opt/nvidia/deepstream/deepstream-6.0/sources/DeepStream-Yolo/ && deepstream-app -c deepstreamCustomizeAppConfig.txt

# ------------- pytorch -------------

# RTSPストリーミングを通じて分析させる場合はxhostにlocalを追加させなくてはいけない（権限がないため）
up: ## Docker コンテナを起動させる
	xhost +local:
	docker-compose up

# ホスト側からみたdockerのIPアドレスを入れる
# ホスト側からip aコマンドを実行したときにdocker0という箇所を参考にする
# detect-streaming hostIpForDocker="172.17.0.1"
detect-streaming: ## RTSPストリーミングを分析する
	python3.8 detect.py --source rtsp://$(hostIpForDocker):8554/camera --weights yolov5s.pt

# Self-Documented Makefile
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
