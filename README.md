# docker-zendaopms

GitLab 是一个用于仓库管理系统的免费开源项目，它实现了一个自托管的Git项目仓库，可通过Web界面进行访问公开的或者私人项目。

 GitLab 10.2.2 已经发布，该版本增加了改进计划、可靠性和部署等的功能。其中值得关注的的是企业版中引入了新的可配置的 issue 看板功能，该功能为团队提供更多灵活的可能性，因为这使得项目(Project)的看板和群组(Group)的看板完全可配置。
<img />

部分更新内容如下：
1. git 中的安全漏洞的修复，可以利用这个漏洞在 GitLab 中执行任意 shell 命令。
2. 安全修复程序解决了 GitLab导出文件中的符号链接的使用问题，该问题会导致攻击者可使用此链接用于复制任意存储库的内容。
3. 当 Redis 不可用时，防止将坏数据添加到应用程序设置中 !12750
4. 在管理员的 GET/用户端点中返回`is_admin`属性 !12811
5. 几个安全修复程序，包括两个持久性跨站脚本（XSS）漏洞的修复程序，一个开放的重定向漏洞，更改用户名时可能留下后面和泄露可能的问题，私密 issue 名称中的信息泄漏漏洞以及 Ruby 和 libxml2 的安全性更新。
  6.Markdown 编辑器中的跨站脚本（XSS）漏洞
  7.过滤器没有正确地从URL方案中剥离无效字符，因此容易受到Markdown支持的任何持久的XSS攻击。 #38267
  8.搜索栏中的跨站脚本（XSS）漏洞
  9.用户名没有被正确的HTML转义，过滤器将允许任意脚本执行。 #37715
  10.Bug修复，包括：
  CE/EE: Fix diff parser so it tolerates to diff special markers in the content (!14848)
  CE/EE: Fix cancel button not working while uploading on the new issue page (!15137)
  CE/EE: Render 404 when polling commit notes without having permissions (!15140)
  CE/EE: Fix webhooks recent deliveries (!15146)
  CE/EE: Fix issues with forked projects of which the source was deleted (!15150)
  CE/EE: Remove Filesystem check metrics that use too much CPU to handle requests (!15158)
  CE/EE: Avoid regenerating the ref path for the environment (!15167)
  此外，还有很多其他重要的更新，[详情点此查看](https://about.gitlab.com/2017/11/22/gitlab-10-2-released/)。