### Visionフレームワークを用いたTextRecognizer
- Visionテキスト認証の練習及び応用のための試行錯誤を記録したリポジトリ

### 結果
- 2022年のiOS16より、日本語と韓国語の認識が可能となった。
- GCP OCRテキストより、スピードは若干遅いが、精度に関する大きい差は感じなかった。
- GCPのAPIはrequest回数の標準基準を超えると有料になっちゃうので、Visionに変更することで、コストの削減ができた。
- Appleプラットフォームの内装フレームワークであるため、Request時にNetworkは介さずに行える -> プロセスにおける１ステップの削減ができる

### 結論・感想
- これから、テキスト認証は、Visionかな...？
- Appleのエコシステムの中で完結できるものは、変えていこう！ (例: Cocoa Pods -> SPMへの推進なども含めて)
(ただし、社内やチーム内の議論を通して、効率性と生産性も考慮して決めること)
