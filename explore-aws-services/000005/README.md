## Create a database on Amazon Relational Database Service (Amazon RDS)

Use following commands to manipulate infrastructure in your required environment effortlessly. (Remember to set up your AWS credentials)

### init

Create S3 backend and initialize your desired environment.


#### Usage

```bash
./scripts/init.sh [ENVIRONMENTS]
```

### apply

ABCXYZ.

#### Usage

```bash
./scripts/apply.sh [ENVIRONMENTS]
```

### destroy

 Destroy infrastructure managed by your particular Terraform configurations.

#### Usage

```bash
./scripts/destroy.sh [ENVIRONMENTS]
```

### Environments

| Environment  | Description |
| ------------- | ------------- |
| dev  | An environment for development workloads (i.e., feature development)  |
| stage  | An environment for pre-production workloads (i.e., testing)  |
| prod  | An environment for production workloads (i.e., user-facing apps)  |
| all | All three environment will be choosen|