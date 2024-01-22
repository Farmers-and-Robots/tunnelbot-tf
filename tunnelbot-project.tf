resource "google_project" "tunnelbot" {
  provider = google-beta

  project_id = "tunnelbot-${var.color}"
  name       = "tunnelbot-${var.color}"
  org_id     =  var.org_id

  labels = {
    "firebase" = "enabled"
  }
}

resource "google_firebase_project" "tunnelbot_firebase_project" {
  provider = google-beta
  project  = google_project.tunnelbot.project_id
}

resource "google_firebase_web_app" "tunnelbot_web_app" {
  provider = google-beta
  project = google_project.tunnelbot.project_id
  display_name = google_project.tunnelbot.name
}

data "google_firebase_web_app_config" "tunnelbot_config" {
  provider   = google-beta
  web_app_id = google_firebase_web_app.tunnelbot_web_app.app_id
}

resource "google_storage_bucket" "tunnelbot_bucket" {
  provider = google-beta
  name     = "tunnelbot_web_app"
  location = "US"
}

resource "google_storage_bucket_object" "tunnelbot_config" {
  provider = google-beta
  bucket = google_storage_bucket.tunnelbot_bucket.name
  name = "firebase-config.json"

  content = jsonencode({
    appId              = google_firebase_web_app.tunnelbot_web_app.app_id
    apiKey             = data.google_firebase_web_app_config.tunnelbot_config.api_key
    authDomain         = data.google_firebase_web_app_config.tunnelbot_config.auth_domain
    databaseURL        = lookup(data.google_firebase_web_app_config.tunnelbot_config "database_url", "")
    storageBucket      = lookup(data.google_firebase_web_app_config.tunnelbot_config "storage_bucket", "")
    messagingSenderId  = lookup(data.google_firebase_web_app_config.tunnelbot_config "messaging_sender_id", "")
    measurementId      = lookup(data.google_firebase_web_app_config.tunnelbot_config "measurement_id", "")
  })
}





