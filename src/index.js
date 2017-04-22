require('./main.css')
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

receiveTestData()

var app = Elm.Main.embed(root)

auth.onAuthStateChanged(function (user) {
  if (user) {
    app.ports.incoming.send('login|' + user.email)
  } else {
    app.ports.incoming.send('logout')
  }
})

app.ports.outgoing.subscribe(function (data) {
  var dataChunks = data.split('|')
  var type = dataChunks[0]
  var user = dataChunks[1]
  var pass = dataChunks[2]
  if (type === 'login') {
    auth.signInWithEmailAndPassword(user, pass)
  } else if (type === 'signup') {
    auth.createUserWithEmailAndPassword(user, pass)
  } else if (type === 'logout') {
    auth.signOut()
  }
})
