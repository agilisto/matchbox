CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `keywords` text,
  `ad_copy` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `link` varchar(255) default NULL,
  `link_text` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `last_indexed_at` datetime default NULL,
  `last_refreshed_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `identifier` varchar(255) default NULL,
  `homepage_url` varchar(255) default NULL,
  `feed_url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_fetched_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_sites_on_identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `site_id` int(11) default NULL,
  `uri` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `content` varchar(255) default NULL,
  `expired_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `name` varchar(100) default '',
  `email` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(40) default NULL,
  `remember_token_expires_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20080707110543');

INSERT INTO schema_migrations (version) VALUES ('20080707124038');

INSERT INTO schema_migrations (version) VALUES ('20080707124329');

INSERT INTO schema_migrations (version) VALUES ('20080708105302');

INSERT INTO schema_migrations (version) VALUES ('20080710150840');

INSERT INTO schema_migrations (version) VALUES ('20080711071401');

INSERT INTO schema_migrations (version) VALUES ('20080711072646');