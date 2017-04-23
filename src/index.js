var Elm = require('./Main.elm')

var root = document.getElementById('root')

var config = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.FIREBASE_DATABASE_URL,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID
}
var firebaseApp = global.firebase.initializeApp(config)

var database = firebaseApp.database()
var auth = firebaseApp.auth()

function receiveTestData () {
  database.ref('/testdata').once('value').then(function (snapshot) {
    return snapshot.val()
  }).then(console.log.bind(console)).catch(console.log.bind(console))
}

var app = Elm.Main.embed(root, process.env.NODE_ENV !== 'production')

auth.onAuthStateChanged(function (user) {
  if (user) {
    app.ports.incoming.send({
      type: 'login',
      payload: {
        email: user.email
      }
    })
  } else {
    app.ports.incoming.send({
      type: 'logout',
      payload: {}
    })
  }
})

app.ports.outgoing.subscribe(function (data) {
  var type = data.type
  var payload = data.payload
  if (type === 'login') {
    auth.signInWithEmailAndPassword(payload.email, payload.pass)
    .catch(function (err) {
      app.ports.incoming.send({
        type: 'loginerror',
        payload: {
          message: JSON.stringify(err)
        }
      })
    })
  } else if (type === 'signup') {
    auth.createUserWithEmailAndPassword(payload.email, payload.pass)
    .catch(function (err) {
      app.ports.incoming.send({
        type: 'signuperror',
        payload: {
          message: JSON.stringify(err)
        }
      })
    })
  } else if (type === 'logout') {
    auth.signOut()
  }
})
