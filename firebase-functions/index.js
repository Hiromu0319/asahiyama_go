const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.onPostCreated = onDocumentCreated("Posts/{docId}", async (event) => {
//    try {
//      const newPostData = event.data.data();
//      const postId = event.params.docId;
//      const userId = newPostData.userId;
//      const name = newPostData.name;
//      const imagePath = newPostData.imagePath;
//      const postImageUrl = newPostData.postImageUrl;
//      const pushToken = newPostData.pushToken;
//      const category = newPostData.category;
//      const message = newPostData.message || "";
//      const likeCount = newPostData.likeCount;
//      const commentCount = newPostData.commentCount;
//      const createdAt = newPostData.createdAt;
//
//      await db.collection("Users")
//        .doc(userId)
//        .collection("posts")
//        .doc(postId)
//        .set({
//          userId: userId,
//          postImageUrl: postImageUrl,
//          message: message,
//          createdAt: createdAt,
//        });
//
//      await db.collection(category)
//        .doc(postId)
//        .set({
//          userId: userId,
//          name: name,
//          imagePath: imagePath,
//          postImageUrl: postImageUrl,
//          pushToken: pushToken,
//          message: message,
//          likeCount: likeCount,
//          commentCount: commentCount,
//          createdAt: createdAt,
//        });
//
//      console.log(`Post ${postId} copied successfully for user ${userId}!`);
//    } catch (error) {
//      console.error("Error copying post data:", error);
//    }
  });
