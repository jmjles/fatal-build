#$pyFunction
def GetLSProData(page_data,Cookie_Jar,m,url = ''):
    from resources.lib.modules import client,control
    if not control.infoLabel('Container.PluginName') == 'plugin.video.thecrew': return
    import re
    r = re.findall('(?s)<ul class="competitions">.*?href="([^"]*)">\s*([^<]*)', page_data)
    return r