# Cats

Amazing Sinatra webapp that returns an URL for a random cat picture on its `/` endpoint.

## Configuration

You may set these variables through the process's ENV:

- `RACK_ENV`: Defaults to `production`.
- `PORT`: Defaults to `8000`.
- `WEB_CONCURRENCY`: Number of processes managed by [Puma](http://puma.io/).
Defaults to `1`.
- `MAX_THREADS`: Number of threads per process. Defaults to `1`.

## Running it

If you're bundling the gems, use `bundle exec puma`; otherwise, `puma` is enough.

# Deployment Infrastructure Documentation

## Project Overview and Objectives

This project implements a comprehensive deployment infrastructure for a Sinatra-based Ruby application using Docker, Docker Compose, CI/CD (GitHub Actions), Ansible, Terraform, and AWS CodeDeploy. The objective is to achieve zero-downtime deployments with Blue/Green or Canary deployment strategies while maintaining a scalable and fault-tolerant architecture.

---

## Folder Structure and File Organization

```
/terraform/
  main.tf                # Contains all AWS resources and CodeDeploy configuration
  variables.tf           # Variable definitions
  outputs.tf             # Resource outputs
  /templates/            # User data templates, etc.

/ansible/
  deploy.yml             # Main playbook for deploying the Sinatra application
  roles/
    app/
      tasks/
        main.yml         # Application deployment logic
      templates/
        start.sh.j2      # Template for start.sh with dynamic ports

/.github/workflows/
  deploy.yml             # GitHub Actions workflow for CI/CD

Dockerfile                # Containerizes the Sinatra app
start.sh                  # Entry point script with dynamic startup delays
appspec.yml               # CodeDeploy application specification
```

---

## Docker and Docker Compose Setup

* **Objective:** Containerize the Sinatra application using Docker and manage multi-container deployments using Docker Compose.

**Dockerfile:**

* Based on `ruby:3.2` image
* Includes startup script (`start.sh`) with a random sleep timer to simulate staggered startup times
* Exposes port `8000`

**docker-compose.yml:**

* Defines the app service with build and environment configuration
* Health checks are included to verify readiness of the app

---

## CI/CD Pipeline Implementation

* **Objective:** Automate build, testing, and deployment processes using GitHub Actions.
* **Workflow:** `.github/workflows/deploy.yml`

  * Steps:

    * Check out the repository
    * Build the Docker image
    * Run tests
    * Deploy using Ansible
    * Trigger Terraform to provision infrastructure
    * Deploy application using CodeDeploy

---

## Ansible Deployment and Configuration

* **Objective:** Configure and deploy the Sinatra application on EC2 instances using Ansible.
* **Main Playbook (`deploy.yml`):**

  * Deploys application artifacts
  * Configures and starts the Sinatra app using the `start.sh.j2` template
  * Ensures application dependencies are installed

**Roles:**

* `app`: Handles the application deployment, including copying the `start.sh.j2` template and creating a systemd service for Puma.

---

## Terraform Infrastructure Provisioning

* **Objective:** Provision the complete AWS infrastructure using Terraform.
* **Resources Defined:**

  * VPC, ELB, Auto Scaling Group, EC2 instances
  * IAM Role for CodeDeploy
  * CodeDeploy application and deployment group

**Key Files:**

* `main.tf`: Contains all resource definitions
* `variables.tf`: Parameterizes key values (e.g., region, instance type)
* `outputs.tf`: Exposes important values such as ELB DNS name and CodeDeploy application name

---

## CodeDeploy Integration

* **Objective:** Implement Blue/Green or Canary deployments using AWS CodeDeploy.
* **Configuration:**

  * `appspec.yml`: Defines lifecycle hooks (before\_install, after\_install, start\_server, validate\_service)
  * `before_install.sh`, `after_install.sh`, `start_server.sh`, `validate_service.sh`: Scripts to handle lifecycle events during deployment

---

## Testing and Verification Steps

* Verify Docker container by running:

  ```bash
  docker-compose up --build
  ```
* Verify Terraform infrastructure by running:

  ```bash
  terraform apply
  ```
* Verify deployment via CodeDeploy:

  * Check the CodeDeploy console for deployment status
  * Monitor ALB health checks and instance status

---

## Known Issues and Future Enhancements

* Implement rollback mechanisms for failed deployments
* Add log collection and aggregation for monitoring
* Implement more comprehensive health checks and monitoring
