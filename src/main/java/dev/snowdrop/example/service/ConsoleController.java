package dev.snowdrop.example.service;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ConsoleController {

    @RequestMapping(value="/console", method = RequestMethod.GET)
    public String console(){
        return "js-console";
    }
}
