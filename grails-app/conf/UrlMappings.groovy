class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
        "/" {
            controller = "dashboard"
            action = "index"
        }
        "/login/$action?"(controller: "login")
        "/logout/$action?"(controller: "logout")
        "500"(controller: "dashboard", action: "index")
    }
}
