# deepstream-yolov5-application-on-jetson
deepstream-yolov5-application-on-jetson は、NVIDIA Jetson 上で YOLOv5 と DeepStream を使用し、動画から物体・人物を検出するマイクロサービスです。


## 動作環境

* NVIDIA Jetson
    * JetPack 4.6
    * DeepStream 6.0
    * nvidia-container-runtime
* Docker
* Docker Compose v2
* GNU Make

## pytorch-yolov5について
PyTorch が入っているNvidia製のDockerイメージです。

## 動作手順

### 重みファイル（yolov5n.wtsとyolov5n.cfg）の生成

学習モデルから重みファイルを生成する際は、pytorch-yolov5のdockerコンテナを使用します。  
#### pytorch-yolov5をビルド
学習モデルから重みファイルを生成するため、pytorch-yolov5のDockerコンテナを以下のコマンドでビルドしてください。  
当該イメージがビルドされると、yolov5n.wtsとyolov5n.cfgがmodels配下に生成されます。
modelsディレクトリはマウントされています。
```
make build-pytorch
```

### 動画解析
deepstream-yolov5のコンテナは、pytorch-yolov5のコンテナから生成された学習モデルの重みファイルを基に動画の解析を行います。
#### deepstream-yolov5をビルド
以下のコマンドで、deepstream-yolov5をビルドしてください。  

```
make build-deepstream
```

#### 解析を行う動画ファイルを置く
対象の動画ファイルをvideos配下に置いてください。
デフォルトではsomething.mp4を解析します。
違う名前のファイルや別のディレクトリの動画ファイルを指定する場合は、
deepstreamCustomizeAppConfig.txtを編集してください。
```
cp {video directory path}/something.mp4 videos
```

#### 動画を解析する
以下のコマンドを実行すると、videos配下にout.mp4という名前で書き出しされます。
```
make exec
```
