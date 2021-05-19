/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package dev.snowdrop.example.jwt;

import java.util.*;

import dev.snowdrop.example.SecurityConfiguration;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;

/**
 * Converts a Keycloak JWT token to {@link AbstractAuthenticationToken}.
 */
public class KeycloakAuthenticationConverter implements Converter<Jwt, AbstractAuthenticationToken> {
    private Logger logger = LoggerFactory.getLogger(KeycloakAuthenticationConverter.class);

    private final JwtAuthenticationConverter delegate;

    public KeycloakAuthenticationConverter() {
        this.delegate = new JwtAuthenticationConverter();
        this.delegate.setJwtGrantedAuthoritiesConverter(jwt -> convertRoles(extractRoles(jwt)));
    }

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        return delegate.convert(jwt);
    }

    private List<GrantedAuthority> convertRoles(Set<String> keycloakRoles) {
        List<GrantedAuthority> grantedAuthorities = new LinkedList<>();
        for (String role : keycloakRoles) {
            grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_" + role));
        }
        return grantedAuthorities;
    }

    @SuppressWarnings("unchecked")
    private Set<String> extractRoles(Jwt jwt) {
//        Map<String, Object> realmAccess = (Map<String, Object>) jwt.getClaims().get("realm_access");
//        List<String> roles = (List<String>) realmAccess.get("roles");
        Set<String> roles = extractRolesFromGroups(jwt);
//        Set<String> roles = extractRolesFromClients(jwt);

        logger.info("[extractRoles] {}", roles);
        return roles;
    }

    private Set<String> extractRolesFromGroups(Jwt jwt) {
        JSONArray groups = (JSONArray) jwt.getClaims().get("groups");

        Set<String> roles = new HashSet<>();
        for (Object s : groups) {
            roles.add(s.toString());
        }

        return roles;
    }

    private Set<String> extractRolesFromClients(Jwt jwt) {
        Map<String, Object> resourceAccess = (Map<String, Object>) jwt.getClaims().get("resource_access");

        Set<String> roles = new HashSet<String>();
        for (String key : resourceAccess.keySet()) {
            logger.debug("[extractRoles] key {}", key);
            JSONObject json = (JSONObject) resourceAccess.get(key);

            logger.debug("[extractRoles] json {}", json);

            for (Object s : (JSONArray) json.get("roles")) {
                roles.add(s.toString());
            }
        }
        return roles;
    }
}
