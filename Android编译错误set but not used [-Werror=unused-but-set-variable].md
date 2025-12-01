	今天编译的时候出现set but not used [-Werror=unused-but-set-variable]这个错误，大致意思定义了一个变量或者方法但是没去用，解决这个错误要么用这个方法或者变量，要么就在Android.mk中找到-Werror 这个Flag，然后删掉它。
