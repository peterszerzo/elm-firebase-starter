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
var storage = firebaseApp.storage()

var dbGet = function(ref) {
  return database.ref(ref).once('value').then(function (snapshot) {
    return snapshot.val()
  })
}

var dbSet = function(ref, data) {
  return database.ref(ref).set(data)
}

var app = Elm.Main.embed(root, process.env.NODE_ENV !== 'production')

auth.onAuthStateChanged(function (user) {
  if (user) {
    app.ports.incoming.send({
      type: 'authstatechange',
      payload: {
        email: user.email,
        uid: user.uid
      }
    })
  } else {
    app.ports.incoming.send({
      type: 'authstatechange',
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
  } else if (type === 'fetchprofile') {
    dbGet('/users/' + payload.uid).then(function (data) {
      app.ports.incoming.send({
        type: 'profile',
        payload: {
          uid: payload.uid,
          data: JSON.stringify(data)
        }
      })
    })
  } else if (type === 'saveprofile') {
    dbSet('/users/' + payload.uid, payload.data).then(function () {
      app.ports.incoming.send({
        type: 'profilesaved',
        payload: {}
      })
    })
  } else if (type === 'uploadprofileimage') {
    var file = document.getElementById(payload.fileInputFieldId).files[0]
    var ref = '/' + payload.uid + '/' + file.name
    storage.ref(ref).put(file).then(function (snapshot) {
      app.ports.incoming.send({
        type: 'profileimageuploaded',
        payload: {
          downloadUrl: snapshot.downloadURL,
          ref: ref
        }
      })
    })
  }
})
