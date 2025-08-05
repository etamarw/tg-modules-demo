# Terragrunt Modules Demo

This repository contains reusable Terraform modules designed to work with Terragrunt, along with Renovate configuration for automated dependency management.

## Repository Structure

```
tg-modules-demo/
├── modules/                    # Reusable Terraform modules
│   ├── vpc/                   # VPC module with standard networking setup
│   └── security-groups/       # Security groups module with 3-tier architecture
├── .github/
│   └── CODEOWNERS            # Code ownership and review requirements
└── renovate.json             # Renovate app configuration
```

## Modules

### VPC Module (`modules/vpc/`)
- Creates a VPC with public and private subnets across multiple availability zones
- Configurable NAT and VPN gateways
- Uses `terraform-aws-modules/vpc/aws` as the underlying module
- Provides VPC ID as output for dependent modules

### Security Groups Module (`modules/security-groups/`)
- Creates a 3-tier security group architecture (web, app, database)
- Web tier: Allows HTTP/HTTPS from configurable CIDR blocks
- App tier: Allows traffic from web tier on port 8080
- Database tier: Allows MySQL traffic from app tier
- Uses `terraform-aws-modules/security-group/aws` as the underlying module
- **Depends on VPC module** for VPC ID input

## Renovate Integration

This repository uses the **Renovate GitHub App** for automated dependency management. The main Renovate workflow will be in your **live repository** where:

- Renovate monitors this modules repository for new releases/tags
- Creates PRs in the live repo when module versions should be updated  
- Manages the actual infrastructure deployment dependencies

### Renovate App Setup

1. **Install the Renovate GitHub App** on your repository from: https://github.com/apps/renovate
2. **Configure the app** to run on this repository  
3. **The `renovate.json` configuration** will automatically be detected and used

### Renovate in This Modules Repository

The included Renovate configuration (`renovate.json`) will:
- Monitor Terraform provider versions in module `versions.tf` files
- Monitor upstream Terraform module versions in module `main.tf` files
- Create PRs to update module dependencies
- Run weekly to keep module dependencies current

### Renovate in Your Live Repository

In your live Terragrunt repository, you'll need a separate Renovate configuration that:
- Monitors this modules repository for new tags/releases
- Creates PRs to update module source references
- Manages infrastructure-specific dependencies

## Module Dependencies

The modules in this repository demonstrate a simple dependency pattern:

1. **VPC Module**: Independent module that creates the base networking infrastructure
2. **Security Groups Module**: Depends on VPC module for the VPC ID (when used in live repo)

## Usage in Live Repository

To use these modules in your live Terragrunt repository:

1. **Reference modules using Git sources with specific versions:**
   ```hcl
   # In your live repo: live/dev/us-west-2/vpc/terragrunt.hcl
   terraform {
     source = "git::https://github.com/etamarw/tg-modules-demo.git//modules/vpc?ref=v1.0.0"
   }
   
   # In your live repo: live/dev/us-west-2/security-groups/terragrunt.hcl
   terraform {
     source = "git::https://github.com/etamarw/tg-modules-demo.git//modules/security-groups?ref=v1.0.0"
   }
   ```

2. **Set up dependencies using Terragrunt's `dependency` block:**
   ```hcl
   # In security-groups/terragrunt.hcl
   dependency "vpc" {
     config_path = "../vpc"
     mock_outputs = {
       vpc_id = "vpc-00000000"
     }
   }
   
   inputs = {
     vpc_id = dependency.vpc.outputs.vpc_id
     # ... other inputs
   }
   ```

3. **Configure Renovate in your live repo** to monitor this modules repository for updates

4. **Deploy in dependency order:**
   ```bash
   # In your live repo
   cd live/dev/us-west-2/vpc
   terragrunt apply
   
   cd ../security-groups
   terragrunt apply
   ```

## Development

### Adding New Modules

1. Create a new directory under `modules/`
2. Include `versions.tf`, `main.tf`, `variables.tf`, and `outputs.tf`
3. Use external module sources where appropriate
4. Follow the existing patterns for provider and module version constraints

### Testing

Test modules by using them in a live repository or create temporary test configurations:

```bash
# Create test configurations in your live repo
mkdir -p test/vpc test/security-groups

# Test VPC module
cd test/vpc
terragrunt plan

# Test security groups module (after VPC is applied)
cd ../security-groups
terragrunt plan
```

### Versioning

This repository should be tagged with semantic versions (e.g., `v1.0.0`) for use in live repositories.

## Security

- All modules follow AWS security best practices
- Security groups implement a 3-tier architecture with proper traffic isolation
- VPC uses public and private subnets for proper network segmentation
- All modules use least-privilege access patterns

## Contributing

1. Create feature branches for new modules or updates
2. Test changes with the example configurations
3. Update this README if adding new modules
4. Tag releases with semantic versions