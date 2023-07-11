# assign-role
勉強会で担当者を決めたり、誰かを指名したりするとき用のルーレットツール

```
USAGE: assign-role [--newface <newface>] [--remove <remove>] [--pick <pick>] [--roulette] [--list]

OPTIONS:
  -n, --newface <newface> Add new member.
  -r, --remove <remove>   Remove member.
  -p, --pick <pick>       Number of people you would like to assign to the role
  --roulette              Pick up one of members
  --list                  Show members list
  -h, --help              Show help information.
```

## How to use
```
git clone https://github.com/Ryomm/assign-role
cd assign-role
swift build -c release
.build/release/assignRole -h
```

`.build/release/assignRole --pick 3` などで3人選びます。
選ばれた項目はフラグが立ち、1周するまで選出対象外となります。

初めて使用する場合は項目の登録が必要です。
`.build/release/assignRole -n someone` のようにして登録してください。
登録されている項目一覧とフラグの状況は `.build/release/assignRole --list` で閲覧可能です。

誰か1人を選出したい場合は `.build/release/assignRole --roulette` を実行します。
このオプションはフラグを立てません。
