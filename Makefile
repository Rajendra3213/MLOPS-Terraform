.PHONY: help init plan apply destroy fmt validate clean

ENV ?= dev

help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan infrastructure changes"
	@echo "  apply     - Apply infrastructure changes"
	@echo "  destroy   - Destroy infrastructure"
	@echo "  fmt       - Format Terraform files"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  clean     - Clean Terraform files"
	@echo ""
	@echo "Usage: make <target> ENV=<dev|staging|prod>"
	@echo "Example: make plan ENV=dev"

init:
	terraform init

plan:
	terraform plan -var-file="environments/$(ENV)/terraform.tfvars" -out=tfplan

apply:
	terraform apply -var-file="environments/$(ENV)/terraform.tfvars"

destroy:
	terraform destroy -var-file="environments/$(ENV)/terraform.tfvars"

fmt:
	terraform fmt -recursive

validate:
	terraform validate

clean:
	rm -rf .terraform .terraform.lock.hcl tfplan
