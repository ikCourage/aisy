ais&y_ui 是扩展 aisy 的 UI 类，给美工用的，将 ais&y_ui.swc 放到 Flash CS 的安装目录下的 /Common/Configuration/ActionScript 3.0/libs
然后就可以使用 jsfl 来创建程序可用的元件了

ais&y_ui_demo 是使用技巧，其中讲了通过 AisyAutoClear 来管理 ais&y_ui 生成的素材，并且描述了可以通过 USprite 的 clear 来清空侦听和显示对象



运行 jsfl 下的 install.jsfl 会自动安装

jsfl 对应于 Flash CS 上方工具栏中的命令，这里列举的所有 jsfl 都会添加进命令中

jsfl 的使用说明：


MoveSelectionToCenterPoint.jsfl                         将舞台上所选内容整体移动到中心点

MoveSelectionToTopLeftPoint.jsfl                        将舞台上所选内容整体移动到左上角



UButtonUIFromEdit.jsfl                                  筛选舞台上所选内容中的按钮，将其转换为 UButtonUI

UButtonUIFromLib.jsfl                                   筛选库中所选内容中的按钮，将其转换为 UButtonUI



UMovieClipUIFromEdit.jsfl                               筛选舞台上所选内容中的影片剪辑，将其转换为 UMovieClipUI

UMovieClipUIFromLib.jsfl                                筛选库中所选内容中的影片剪辑，将其转换为 UMovieClipUI

UMovieClipUIConvert.jsfl                                将舞台上所选内容整体转换为一个新的 UMovieClipUI


ButtonUIFromLib.jsfl                                    将 3 帧（事实上可以存在第 4 帧：选中状态）的影片剪辑转换成 ButtonUI



可以在 Flash CS 上方工具栏中
    编辑 =》
    快捷键 =》
    当前设置后的第一个按钮 =》（必须在副本上修改）
    命令
来添加快捷键