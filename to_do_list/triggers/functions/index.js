/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const { Translate } = require('@google-cloud/translate').v2;

const translate = new Translate();

exports.translateTask = functions.firestore.document('tasks/{taskId}')
  .onCreate(async (snapshot, context) => {
    const taskData = snapshot.data();
    
    // Asegúrate de que tienes un campo 'title' y 'description' en tus tareas
    const title = taskData.Title;
    const description = taskData.Description;

    // Traduce el título y la descripción a inglés
    const [titleTranslation] = await translate.translate(title, 'en');
    const [descriptionTranslation] = await translate.translate(description, 'en');
    
    // Actualiza la tarea con las traducciones
    return snapshot.ref.update({
      translatedTitle: titleTranslation,
      translatedDescription: descriptionTranslation
    });
  });


