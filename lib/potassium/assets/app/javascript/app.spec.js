import { shallowMount } from '@vue/test-utils';
import App from 'app';

describe('App', () => {
  test('is a Vue instance', () => {
    const wrapper = shallowMount(App);
    expect(wrapper.isVueInstance()).toBeTruthy();
  });

  it('displays message on load', () => {
    const wrapper = shallowMount(App);
    expect(wrapper.find('p').text()).toEqual('Hello Vue!');
  });
});
