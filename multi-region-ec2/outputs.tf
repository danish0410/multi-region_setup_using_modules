output "regions" {
  description = "List of regions deployed"
  value       = keys(module.region)
}
