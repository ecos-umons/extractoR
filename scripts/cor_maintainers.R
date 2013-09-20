pdf("scatter.pdf")

x <- V(g2)$packages
y <- V(g2)$num.perrors
cor.test(x, y, method="spearman")
cor.test(x[y > 0], y[y > 0], method="spearman")
plot(x, y,
     xlab="# maintained packages",
     ylab="# packages with errors")
plot(x[y > 0], y[y > 0],
     xlab="# maintained packages",
     ylab="# packages with errors")

x <- degree(g2, mode="in")
y <- V(g2)$num.perrors.rel
cor.test(x, y, method="spearman")
cor.test(x[y > 0], y[y > 0], method="spearman")
plot(x, y,
     xlab="# reverse dependencies",
     ylab="% packages with errors")
plot(x[y > 0], y[y > 0],
     xlab="# reverse dependencies",
     ylab="% packages with errors")

x <- degree(g2, mode="in")
y <- V(g2)$packages
cor.test(x, y, method="spearman")
plot(x, y, log="xy",
     xlab="# reverse dependencies",
     ylab="# maintained packages")

x <- V(g2)$packages
y <- V(g2)$num.perrors.rel
cor.test(x, y, method="spearman")
cor.test(x[y > 0], y[y > 0], method="spearman")
plot(x, y,
     xlab="# maintained packages",
     ylab="% packages with errors")
plot(x[y > 0], y[y > 0],
     xlab="# maintained packages",
     ylab="% packages with errors")

dev.off()
