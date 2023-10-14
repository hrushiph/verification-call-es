terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = ">= 5.2.6" // Replace with the desired version constraint
    }
  }
}

variable "heroku" {
  type = map
  default = {
    email = "hrushi.ph@gmail.com"
    api_key = "14472420-fa95-4a96-8e62-98cd0250aec6"
  }
}

variable "twilio" {
  type = map
  default = {
    account_sid = "ACe2b8d8a339e6c1285667718cd754b9be"
    auth_token = "5c5ef9c09dd6eb7dbf9de615764220f9"
    workspace_sid = "WS4d8e9d4ce0d0c4ba37446d1d399b25e2"
    chat_service_sid = "IS69bb745859a94bdf94bc955e85475ef6"
    api_key_sid = "SKef01159a993f0c471af82034deb7c9a2"
    api_key_secret = "4e45LE1s8GtUnpcJVl2uc3URIvlE8SUl"
  }
}

provider "heroku" {
  email = var.heroku.email
  api_key = var.heroku.api_key
}

resource "heroku_app" "default" {
  name = "verification-call"
  region = "eu"
  sensitive_config_vars = {
    TWILIO_ACCOUNT_SID = var.twilio.account_sid
    TWILIO_AUTH_TOKEN = var.twilio.auth_token
    TWILIO_WORKSPACE_SID = var.twilio.workspace_sid
    TWILIO_CHAT_SERVICE_SID = var.twilio.chat_service_sid
    TWILIO_API_KEY_SID = var.twilio.api_key_sid
    TWILIO_API_KEY_SECRET = var.twilio.api_key_secret
  }
}

resource "heroku_addon" "database" {
  app_id = heroku_app.default.id
  plan = "heroku-postgresql"
}

resource "heroku_build" "contact_center" {
  app_id = heroku_app.default.id
  source {
    url = "https://github.com/hrushiph/verification-call-es/tarball/master"
  }
}