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
var firebaseApp = global.firebase && global.firebase.initializeApp(config)

var database = firebaseApp && firebaseApp.database()
var auth = firebaseApp && firebaseApp.auth()
var storage = firebaseApp && firebaseApp.storage()

var dbGet = function (ref) {
  return database.ref(ref).once('value').then(function (snapshot) {
    return snapshot.val()
  })
}

var dbSet = function (ref, data) {
  return database.ref(ref).set(data)
}

var app = Elm.Main.embed(root, process.env.NODE_ENV !== 'production')

auth.onAuthStateChanged(function (user) {
  if (user) {
    app.ports.incoming.send({
      type: 'auth:state:change',
      payload: {
        email: user.email,
        uid: user.uid
      }
    })
  } else {
    app.ports.incoming.send({
      type: 'auth:state:change',
      payload: {}
    })
  }
})

app.ports.outgoing.subscribe(function (data) {
  var type = data.type
  var payload = data.payload
  var file
  var ref
  switch (type) {
    case 'login':
      return auth.signInWithEmailAndPassword(payload.email, payload.pass)
      .catch(function (err) {
        app.ports.incoming.send({
          type: 'login:error',
          payload: {
            message: JSON.stringify(err)
          }
        })
      })
    case 'signup':
      return auth.createUserWithEmailAndPassword(payload.email, payload.pass)
      .catch(function (err) {
        app.ports.incoming.send({
          type: 'signup:error',
          payload: {
            message: JSON.stringify(err)
          }
        })
      })
    case 'logout':
      return auth.signOut()
    case 'fetch:profile':
      return dbGet('/users/' + payload.uid).then(function (data) {
        app.ports.incoming.send({
          type: 'profile',
          payload: {
            uid: payload.uid,
            data: JSON.stringify(data)
          }
        })
      })
    case 'save:profile':
      return dbSet('/users/' + payload.uid, payload.data).then(function () {
        app.ports.incoming.send({
          type: 'profile:saved',
          payload: {}
        })
      })
  }
})
