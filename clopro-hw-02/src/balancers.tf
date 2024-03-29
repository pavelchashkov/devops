locals {
  network_lb_name     = "network-lb"
  application_lb_name = "app-lb"
}

# Network Load Balancer

resource "yandex_lb_network_load_balancer" "network_lb" {
  name = local.network_lb_name

  listener {
    name = local.network_lb_name
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.network_lb_gr.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}


# Application Load Balancer

resource "yandex_alb_http_router" "app_lb" {
  name = local.application_lb_name
  labels = {
    tf-label    = local.application_lb_name
    empty-label = ""
  }
}

resource "yandex_alb_backend_group" "app_lb" {
  name = local.application_lb_name

  http_backend {
    name             = "test-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_compute_instance_group.app_lb_gr.application_load_balancer[0].target_group_id]
    load_balancing_config {
      panic_threshold = 5
    }
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/"
      }
    }
    http2 = "false"
  }
}

resource "yandex_alb_virtual_host" "app_lb" {
  name           = local.application_lb_name
  http_router_id = yandex_alb_http_router.app_lb.id
  route {
    name = "http"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.app_lb.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "app_lb" {
  name = local.application_lb_name

  network_id = yandex_vpc_network.network.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = local.application_lb_name
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.app_lb.id
      }
    }
  }
}
