import 'package:firebase_auth/firebase_auth.dart';

const List<String> categories = [
  "ホッキョクグマ",
  "トナカイ",
  "シロフクロウ",
  "カバ",
  "キリン",
  "ライオン",
  "ブラッザグエノン",
  "チンパンジー",
  "アビシニアコロンブス",
  "ワオキツネザル",
  "ダチョウ",
  "ヨーロッパフラミンゴ",
  "マヌルネコ",
  "エゾモモンガ",
  "タンチョウ",
  "ゴマフアザラシ",
  "アムールトラ",
  "アムールヒョウ",
  "ユキヒョウ",
  "ボルネオオランウータン",
  "シロテテナガザル",
  "キョン",
  "シセンレッサーバンダ",
  "ニホンザル",
  "エゾシカ",
  "エゾヒグマ",
  "キタキツネ",
  "エゾタヌキ",
  "エゾユキウサギ",
  "エゾクロテン",
  "エゾリス",
  "エゾフクロウ",
  "シマフクロウ",
  "オオワシ",
  "オジロワシ",
  "クマタカ",
  "オオハクチョウ",
  "キンクロハジロ",
  "インドクジャク",
  "アオダイショウ",
  "シンリンオオカミ",
  "アライグマ",
  "ジェフロイクモザル",
  "カピバラ",
  "フンボルトペンギン",
  "チリーフラミンゴ",
  "ベニイロフラミンゴ",
  "キングペンギン",
  "ジェンツーペンギン",
  "イワトビペンギン"
];

String handleException(FirebaseAuthException e) {

  switch (e.code) {
    case 'invalid-email':
      return '指定されたメールアドレスは\n無効です。';
    case 'invalid-credential':
      return '無効な認証情報です。';
    case 'email-already-in-use':
      return '指定されたメールアドレスは\n既に使用されています。';
    case 'wrong-password':
      return 'パスワードが違います。';
    case 'user-disabled':
      return '指定されたユーザーは無効です。';
    case 'user-not-found':
      return '指定されたユーザーは存在しません。';
    case 'too-many-requests':
      return '試行回数が多すぎます。\nしばらく待ってから再試行してください。';
    case 'operation-not-allowed':
      return 'このアカウントでのログインは\n許可されていません。';
    default:
      return '不明なエラーが発生しました\n（${e.code}）。';
  }
}