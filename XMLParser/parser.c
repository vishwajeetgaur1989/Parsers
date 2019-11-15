#include <stdio.h>                                                              
#include <string.h>                                                             
#include <libxml/parser.h> 
char str[BUFSIZ*2];
int is_leaf(xmlNode * node)
{
  xmlNode * child = node;
  while(child)
  {
    if(child->type == XML_ELEMENT_NODE) 
        return 0;
    child = child->next;
  }
  return 1;
}
xmlChar *getAttributes(xmlNode *node) 
{
    int len = 0, i;
    xmlAttr *tmp = node->properties;
    for (i=0; i < BUFSIZ*2; i++)
        str[i] = '\0';
    while (tmp) {
        sprintf(str + len , ":%s:%s:", tmp->name, xmlNodeGetContent(tmp->children));
        len = len + strlen(xmlNodeGetContent(tmp->children)) + strlen(tmp->name) + 3 ; 
        tmp = tmp->next;
    }
    return str;
}

void print_xml(xmlNode * node, int indent_len)
{
    while(node)
    {
        if(node->type == XML_ELEMENT_NODE)
        {
            printf("%*c%s:%s\n", indent_len*2, '-', node->name, 
                is_leaf(node)?xmlNodeGetContent(node):getAttributes(node));
        }
        print_xml(node->children, indent_len + 1);
        node = node->next;
    }
}
 
int main(int argc, char **argv){
  xmlDoc *doc = NULL;
  xmlNode *root_element = NULL;
 
  doc = xmlReadFile(argv[1], NULL, 0);
 
  if (doc == NULL) {
    printf("Could not parse the XML file");
  }
 
  root_element = xmlDocGetRootElement(doc);
 
  print_xml(root_element, 1);
 
  xmlFreeDoc(doc);
  xmlCleanupParser();
}
