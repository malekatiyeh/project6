// A linked list stores values in a chain of "nodes". Each node holds one
// number and the address of the next node, so the nodes can be anywhere in
// memory and the list can grow one node at a time.
//
// This program shows a menu that lets the user print the list, add a number
// to the end of it, or remove a number from it.

#include <stdio.h>
#include <stdlib.h>

// One node in the list. In the last node, next is 0, which marks the end.
typedef struct node
{
    int value;
    struct node *next;
} node_t;

// Each function receives the address of head, not a copy of it. That lets
// addValue and removeValue change head when the first node changes.
void printList(node_t **head);
void addValue(node_t **head, int added);
void removeValue(node_t **head, int removed);

int main()
{
    // head points to the first node. A value of 0 means the list is empty.
    node_t *head = 0;
    
    char selection = 's';
    
    // Keep showing the menu until the user types q.
    while(selection != 'q')
    {
        printf("Available options:\n");
        printf("p - Print linked list\n");
        printf("a - Add value to linked list\n");
        printf("r - Remove value from linked list\n");
        printf("q - Quit\n");
        printf("Choose an option: ");
        // The space before %c skips leftover whitespace, like the Enter key.
        scanf(" %c", &selection);
        
        if(selection == 'p')
        {
            printList(&head);
        }
        else if(selection == 'a')
        {
            int a = 0;
            printf("Type a number to add: ");
            scanf("%d", &a);
            addValue(&head, a);
        }
        else if(selection == 'r')
        {
            int r = 0;
            printf("Type a number to remove: ");
            scanf("%d", &r);
            removeValue(&head, r);
        }
    }
}

// Prints every value in the list, in order.
void printList(node_t **head)
{
    node_t *current = (*head);
    while(current != 0)
    {
        printf("%d", current->value);

        // Move to the next node.
        current = current->next;
        
        // Only print an arrow if another node comes after this one.
        if(current != 0)
        {
            printf(" -> ");
        }
    }
    
    printf("\n");
    
    return;
}

// Adds a new node holding the given value to the end of the list.
void addValue(node_t **head, int added)
{
    node_t *current = (*head);
    
    // If the list is empty, the new node becomes the first node.
    // malloc reserves memory for one node, which stays reserved until freed.
    if((*head) == 0)
    {
        (*head) = (node_t *) malloc(sizeof(node_t));
        (*head)->value = added;
        (*head)->next = 0;
        return;
    }
    
    // Otherwise, walk along the list to find the last node, then attach the
    // new node after it.
    while(current != 0)
    {
        if(current->next == 0)
        {
            current->next = (node_t *) malloc(sizeof(node_t));
            current->next->value = added;
            current->next->next = 0;
            return;
        }
        
        current = current->next;
    }
    
    return;
}

// Removes the first node holding the given value. If no node holds it, the
// list stays the same.
void removeValue(node_t **head, int removed)
{
    // An empty list has nothing to remove.
    if((*head) == 0)
    {
        return;
    }

    node_t *prev = (*head);

    // If the first node matches, head moves to the second node. free gives
    // the old first node's memory back.
    if((*head)->value == removed)
    {
        (*head) = (*head)->next;
        free(prev);
        return;
    }
    
    // Otherwise, check the remaining nodes. prev stays one node behind current.
    node_t *current = (*head)->next;
    
    while(current != 0)
    {
        if(current->value == removed)
        {
            // Link prev to the node after current, which skips over current.
            prev->next = current->next;
            free(current);
            return;
        }
        
        prev = current;
        current = current->next;
    }
    
    return;
}