# App更新插件

安装方式
```
dependencies:
  flutter:
    sdk: flutter
  appupdateplugin:
    git:
      url: git://github.com/xionghaoo/app_update_plugin.git
```

## Android使用请注意
> FileProvider需要提供authority名称，默认是com.pgy.appupdateplugin

可以在local.properties文件中修改成主项目包名
```
dependencyPackageName=com.xxx.xxx
```


















