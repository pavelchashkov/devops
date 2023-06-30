## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.by_name](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.by_name](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | vpc name | `string` | n/a | yes |
| <a name="input_vpc_v4_cidr_blocks"></a> [vpc\_v4\_cidr\_blocks](#input\_vpc\_v4\_cidr\_blocks) | vpc v4\_cidr\_blocks | `list(string)` | n/a | yes |
| <a name="input_vpc_zone"></a> [vpc\_zone](#input\_vpc\_zone) | vpc zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | subnet\_id |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | vpc\_id |
