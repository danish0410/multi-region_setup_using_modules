output "vpc_ids" {
  value = {
    ap-south-1 = try(module.region_ap_south_1["ap-south-1"].vpc_id, null)
    us-east-1  = try(module.region_us_east_1["us-east-1"].vpc_id, null)
    us-east-2  = try(module.region_us_east_2["us-east-2"].vpc_id, null)
  }
}
