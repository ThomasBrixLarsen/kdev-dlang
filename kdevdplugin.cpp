/*************************************************************************************
*  Copyright (C) 2014 by Pavel Petrushkov <onehundredof@gmail.com>                  *
*                                                                                   *
*  This program is free software; you can redistribute it and/or                    *
*  modify it under the terms of the GNU General Public License                      *
*  as published by the Free Software Foundation; either version 2                   *
*  of the License, or (at your option) any later version.                           *
*                                                                                   *
*  This program is distributed in the hope that it will be useful,                  *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of                   *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    *
*  GNU General Public License for more details.                                     *
*                                                                                   *
*  You should have received a copy of the GNU General Public License                *
*  along with this program; if not, write to the Free Software                      *
*  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA   *
*************************************************************************************/

#include "kdevdplugin.h"

#include <ddebug.h>
#include <KPluginFactory>
#include <KAboutData>
#include <language/codecompletion/codecompletion.h>
#include <interfaces/icore.h>
#include <interfaces/ilanguagecontroller.h>

#include "codecompletion/model.h"
#include "dlangparsejob.h"

#include "parser/dparser.h"

K_PLUGIN_FACTORY_WITH_JSON(DPluginFactory, "kdevd.json", registerPlugin<DPlugin>();)
//K_EXPORT_PLUGIN(DPluginFactory(
//    KAboutData("kdevdplugin","kdevdplugin",
//               ki18n("D Plugin"), "0.1", ki18n("D Language Support for KDevelop"), KAboutData::License_GPL)))

using namespace KDevelop;

DPlugin::DPlugin(QObject *parent, const QVariantList &) : KDevelop::IPlugin("kdevdplugin", parent), ILanguageSupport()
{
	KDEV_USE_EXTENSION_INTERFACE(ILanguageSupport)
	
	qCDebug(D) << "D Language Plugin is loaded\n";
	printf("D Language Plugin is loaded!!! OMG!\n");
	
	initDParser();
	
	CodeCompletionModel *codeCompletion = new dlang::CodeCompletionModel(this);
	new KDevelop::CodeCompletion(this, codeCompletion, name());
	
	m_highlighting = new Highlighting(this);
}

DPlugin::~DPlugin()
{
	deinitDParser();
}

ParseJob *DPlugin::createParseJob(const IndexedString &url)
{
	qCDebug(D) << "Creating dlang parse job\n";
	return new DParseJob(url, this);
}

QString DPlugin::name() const
{
	return "D";
}

KDevelop::ICodeHighlighting *DPlugin::codeHighlighting() const
{
	return m_highlighting;
}

#include "kdevdplugin.moc"
