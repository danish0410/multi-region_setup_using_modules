/* ----------------------------------------------------
 * VPC Outputs (AWS Console Friendly)
 * ---------------------------------------------------- */

output "vpcs" {
  description = "VPC details per region (ID, Name, CIDR)"
  value = {
    # ap-south-2 = {
    #   vpc_id   = try(module.region_ap_south_2["ap-south-2"].vpc_id, null)
    #   vpc_name = try(module.region_ap_south_2["ap-south-2"].vpc_name, null)
    #   cidr     = try(var.regions["ap-south-2"].vpc_cidr, null)
    #   region   = "ap-south-2"
    # }

    us-east-2 = {
      vpc_id   = try(module.region_us_east_2["us-east-2"].vpc_id, null)
      vpc_name = try(module.region_us_east_2["us-east-2"].vpc_name, null)
      cidr     = try(var.regions["us-east-2"].vpc_cidr, null)
      region   = "us-east-2"
    }
  }
}
