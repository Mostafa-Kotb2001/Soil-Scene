const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnFieldChange = functions.firestore
    .document("UNITS/{docId}")
    .onUpdate((change, context) => {
      const newValue = change.after.data();
      const previousValue = change.before.data();

      // Check if the specific field 'weater' has changed
      if (newValue.weater !== previousValue.weater &&
       newValue.weater !== true) {
        const payload = {
          notification: {
            title: "Smart Irrigation System",
            body: "Your soil wants water",
          },
        };

        // Send notification to a specific topic or device
        return admin
            .messaging()
            .sendToTopic("your_topic", payload)
            .then((response) => {
              console.log("Notification sent successfully:", response);
            })
            .catch((error) => {
              console.log("Error sending notification:", error);
            });
      }

      return null;
    });
