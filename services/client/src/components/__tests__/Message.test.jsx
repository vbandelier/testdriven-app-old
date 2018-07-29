import React from 'react';
import { shallow } from 'enzyme';
import renderer from 'react-test-renderer';

import Message from '../Message';

const removeSuccessMessage = jest.fn();
const removeDangerMessage = jest.fn();

const testData = [
  {
    messageName: 'Hello, World!',
    messageType: 'success',
    removeMessage: removeSuccessMessage,
  },
  {
    messageName: 'Hello, World!',
    messageType: 'danger',
    removeMessage: removeDangerMessage,
  }
];

testData.forEach((el) => {
  describe(`When given a ${el.messageType} message`, () => {
    it('Message renders properly', () => {
      const wrapper = shallow(<Message {...el} />);
      const element = wrapper.find(`.notification.is-${el.messageType}`);
      expect(element.length).toBe(1);
      const span = wrapper.find('span');
      expect(span.length).toBe(1);
      expect(span.get(0).props.children).toContain(el.messageName);
      const button = wrapper.find('button');
      expect(button.length).toBe(1);
      expect(el.removeMessage).toHaveBeenCalledTimes(0);
      button.simulate('click');
      expect(el.removeMessage).toHaveBeenCalledTimes(1);
    });

    test('Message renders a snapshot properly', () => {
      const tree = renderer.create(
        <Message {...el} />
      ).toJSON();
      expect(tree).toMatchSnapshot();
    });
  });
});
