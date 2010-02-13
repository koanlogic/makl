# New ports collection makefile for:	makl
# Date created:				13 February 2010
# Whom:					<tho@koanlogic.com>
#
# $FreeBSD$
#

PORTNAME=	makl
PORTVERSION=	1.8.1
CATEGORIES=	devel
MASTER_SITES=	http://koanlogic.com/download/makl/

MAINTAINER=	tho@koanlogic.com
COMMENT=	GNU make wrapper and autotools replacement

RUN_DEPENDS=	${LOCALBASE}/bin/gmake:${PORTSDIR}/devel/gmake

NO_BUILD=	yes

MAN1=		makl-conf.1 makl-new.1 makl-tc.1 makl.1
MAN1PREFIX=	${PREFIX}/share
MANCOMPRESSED=	no
USE_GMAKE=	yes

.include <bsd.port.mk>
