locals {
  env     = var.env
  dept    = var.dept
  project = var.project

  prefix = "${var.env}-${var.project}-${var.dept}"
  tags = {
    "env" : "${var.env}",
    "dept" : "${var.dept}",
    "project" : "${var.project}"
  }

} #end locals

